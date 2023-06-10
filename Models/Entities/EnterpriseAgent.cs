namespace Models.Entities
{
    public class EnterpriseAgent
    {
        public string UserId { get; set; }
        public User User { get; set; }
        public int EnterpriseId { get; set; }
        public Enterprise Enterprise { get; set; }
    }
}
