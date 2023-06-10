using AkaratAPIs.Security;
using AqaratAPIs.Services.RealTime;
using BaytyAPIs.DTOs.MessagesDTOs;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.DataProtection;
using Microsoft.AspNetCore.Mvc;
using Models.DataStoreContract;
using Models.Entities;
using Newtonsoft.Json;
using System.Net.WebSockets;
using System.Text;

namespace AkaratAPIs.Controllers
{

    [ApiController]
    public class ChatController : ControllerBase
    {
        private readonly IWebSocketService _wsService;
        private readonly IDataStore _dataStore;
        public ChatController(IWebSocketService wsService, IDataStore dataStore)
        {
            _wsService = wsService;
            _dataStore = dataStore;
        }

        [HttpGet("/messagesList")]
        [Authorize]
        public async Task<ActionResult<IEnumerable<MessageListDTO>>> PrevMessages(string userId)
        {
            try
            {
                var messages = await _dataStore.Messages.LastMessagesForEachUserAsync(userId);
                
                if (messages == null || messages.Count() == 0)
                {
                    return Ok();
                }

                var messagesListDto = new List<MessageListDTO>();

                foreach (var m in messages)
                    messagesListDto.Add(new MessageListDTO
                    {
                        MessageContent = m.MessageContent,
                        Username = (userId == m.SenderId) ? m.Receiver.FirstName + " " + m.Receiver.LastName :
                                                            m.Sender.FirstName + " " + m.Sender.LastName,
                        SecondUserImagePath = (userId == m.SenderId) ? m.Receiver.ImagePath : m.Sender.ImagePath,
                    });

                return Ok(messagesListDto);
    
            } catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, ex.Message);
            }
        }

        [HttpGet]
        [Route("/ws/send/{currentId?}")]
        public async Task SendMessage(string currentId)
        {
            if (HttpContext.WebSockets.IsWebSocketRequest)
            {
                var ws = await HttpContext.WebSockets.AcceptWebSocketAsync();

                if (_wsService.UpdateUser(currentId, ws))
                    Console.WriteLine($"User With Id:{currentId} Connection Updated Successfully");
                else
                {
                    _wsService.ConnectUser(currentId, ws);
                    Console.WriteLine($"User With Id:{currentId} Connected Successfully");
                }

                var msg = new byte[4096];

                var receivedData = await ws.ReceiveAsync(new ArraySegment<byte>(msg), CancellationToken.None);

                while (!receivedData.CloseStatus.HasValue)
                {
                    try
                    {
                        var result = await ws.ReceiveAsync(new ArraySegment<byte>(msg), CancellationToken.None);

                        var message = ConvertArrayOfBytesToMessage(msg.Take(result.Count).ToArray());

                        var receiverSocket = _wsService.GetUser(message.ReceiverId);

                        await _dataStore.Messages.AddAsync(message);

                        if (receiverSocket != null)
                        {
                            await receiverSocket.SendAsync(new ArraySegment<byte>(msg), WebSocketMessageType.Text, false, CancellationToken.None);
                        }
                        await ws.SendAsync(new ArraySegment<byte>(msg), WebSocketMessageType.Text, false, CancellationToken.None);

                    }
                    catch (Exception ex)
                    {
                        await Console.Out.WriteLineAsync($"{ex.Message}");
                    }
                }
            }
        }



        private Message ConvertArrayOfBytesToMessage(byte[] msg) => JsonConvert.DeserializeObject<Message>(Encoding.UTF8.GetString(msg));
    }
}
