using Models.Entities;

namespace Models.IRepositories
{
    public interface IMessageRepository : IGenericRepository<Message, int>
    {
        Task<IEnumerable<Message>> RetrieveMessageForTwoUsersAsync(string firstUserId, string secondUserId);
        Task<IEnumerable<Message>> LastMessagesForEachUserAsync(string userId);
    }
}
