using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace EF_Modeling.Migrations
{
    /// <inheritdoc />
    public partial class AddRelationEnterpriseAgentWithUserAndEnterprise : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {

            migrationBuilder.CreateTable(
                name: "EnterpriseAgent",
                columns: table => new
                {
                    UserId = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    EnterpriseId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_EnterpriseAgent", x => new { x.UserId, x.EnterpriseId });
                    table.ForeignKey(
                        name: "FK_EnterpriseAgent_AspNetUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.NoAction);
                    table.ForeignKey(
                        name: "FK_EnterpriseAgent_Enterprises_EnterpriseId",
                        column: x => x.EnterpriseId,
                        principalTable: "Enterprises",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.NoAction);
                });

            migrationBuilder.CreateIndex(
                name: "IX_EnterpriseAgent_EnterpriseId",
                table: "EnterpriseAgent",
                column: "EnterpriseId");

        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "EnterpriseAgent");
        }
    }
}
