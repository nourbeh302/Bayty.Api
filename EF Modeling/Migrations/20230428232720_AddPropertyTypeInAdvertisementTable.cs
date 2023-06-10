using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace EF_Modeling.Migrations
{
    /// <inheritdoc />
    public partial class AddPropertyTypeInAdvertisementTable : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<bool>(
                name: "IsForRent",
                table: "HousesBase",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<int>(
                name: "PropertyType",
                table: "Advertisements",
                type: "int",
                nullable: false,
                defaultValue: 0);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "IsForRent",
                table: "HousesBase");

            migrationBuilder.DropColumn(
                name: "PropertyType",
                table: "Advertisements");
        }
    }
}
