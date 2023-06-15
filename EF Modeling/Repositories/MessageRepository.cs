using Microsoft.EntityFrameworkCore;
using Models.Entities;
using Models.IRepositories;

namespace EF_Modeling.Repositories
{
    public class MessageRepository : GenericRepository<Message, int>, IMessageRepository
    {
        private readonly AppDbContext _context;
        public MessageRepository(AppDbContext context) : base(context)
        {
            _context = context;
        }

        public async Task<IEnumerable<Message>> LastMessagesForEachUserAsync(string userId)
        {
            return await _context.Messages.Where(m => m.SenderId == userId || m.ReceiverId == userId)
                                          .OrderByDescending(m => m.DateTime)
                                          .DistinctBy(m => new {m.SenderId, m.ReceiverId})
                                          .ToListAsync();
        }

        public async Task<IEnumerable<Message>> RetrieveMessageForTwoUsersAsync(string firstUserId, string secondUserId)
            => await _context.Messages
            .Where(m => (m.SenderId == firstUserId && m.ReceiverId == secondUserId) ||
                        (m.SenderId == secondUserId && m.ReceiverId == firstUserId))
            .ToListAsync();

        private bool MessageOwnersValidator(Message message, string firstUserId, string secondUserId)
        {
            return (message.SenderId == firstUserId && message.ReceiverId == secondUserId) ||
                        (message.SenderId == secondUserId && message.ReceiverId == firstUserId);
        }
    }
}
