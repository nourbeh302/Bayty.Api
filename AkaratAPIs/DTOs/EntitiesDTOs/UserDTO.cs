namespace AqaratAPIs.DTOs.EntitiesDTOs
{
    public class UserDTO
    {
        public string Id { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Address { get; set; }
        public int Age { get; set; }
        public IFormFile? Image { get; set; }
    }
}