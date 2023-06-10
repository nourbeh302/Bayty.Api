using Microsoft.EntityFrameworkCore;
using Models.Entities;
using Models.IRepositories;

namespace EF_Modeling.Repositories
{
    public class UserRepository : GenericRepository<User, string>, IUserRepository
    {
        private readonly AppDbContext _context;
        public UserRepository(AppDbContext context) : base(context)
        {
            _context = context;
        }
        public async Task DeleteUserAsync(string userId)
        {
            try
            {
                var user = await _context.Users.Include(u => u.FavoriteProperties).
                                                Include(u => u.Advertisements).
                    FirstOrDefaultAsync(u => u.Id == userId);


                foreach (var fp in user.FavoriteProperties)
                    _context.FavoriteProperties.Remove(fp);

                foreach (var ad in user.Advertisements)
                    _context.Advertisements.Remove(ad);



                _context.Remove(user);

            } catch
            {
                Console.WriteLine("Exception Happened");
            }
        }
    }
}
