using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace EF_Modeling.Migrations
{
    /// <inheritdoc />
    public partial class AddPropAreaToHouseBaseAndDateTimeToMessage : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<double>(
                name: "Area",
                table: "HousesBase",
                type: "float",
                nullable: false,
                defaultValue: 0.0);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Area",
                table: "HousesBase");
        }
    }
}
