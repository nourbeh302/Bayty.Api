using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace EF_Modeling.Migrations
{
    /// <inheritdoc />
    public partial class deleteKitchenCount : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Kitchens Count",
                table: "HousesBase");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "Kitchens Count",
                table: "HousesBase",
                type: "int",
                nullable: false,
                defaultValue: 0);
        }
    }
}
