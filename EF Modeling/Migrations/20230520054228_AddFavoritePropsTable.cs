using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace EF_Modeling.Migrations
{
    /// <inheritdoc />
    public partial class AddFavoritePropsTable : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "FavoriteProperties",
                columns: table => new
                {
                    UserId = table.Column<string>(type: "nvarchar(450)", nullable: true),
                    AdvertisementId = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.ForeignKey(
                        name: "FK_FavoriteProperties_Advertisements_AdvertisementId",
                        column: x => x.AdvertisementId,
                        principalTable: "Advertisements",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.NoAction);
                    table.ForeignKey(
                        name: "FK_FavoriteProperties_AspNetUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.NoAction);
                });

            migrationBuilder.CreateIndex(
                name: "IX_FavoriteProperties_AdvertisementId",
                table: "FavoriteProperties",
                column: "AdvertisementId");

            migrationBuilder.CreateIndex(
                name: "IX_FavoriteProperties_UserId",
                table: "FavoriteProperties",
                column: "UserId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "FavoriteProperties");
        }
    }
}
