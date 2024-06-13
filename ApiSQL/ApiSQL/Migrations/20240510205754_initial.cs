using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace ApiSQL.Migrations
{
    /// <inheritdoc />
    public partial class initial : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Articulo",
                columns: table => new
                {
                    IdArticulos = table.Column<int>(type: "INTEGER", nullable: false)
                        .Annotation("Sqlite:Autoincrement", true),
                    nombre = table.Column<string>(type: "TEXT", nullable: false),
                    descripcion = table.Column<string>(type: "TEXT", nullable: false),
                    precioUnitario = table.Column<decimal>(type: "TEXT", nullable: false),
                    stock = table.Column<int>(type: "INTEGER", nullable: false),
                    estatus = table.Column<int>(type: "INTEGER", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Articulo", x => x.IdArticulos);
                });

            migrationBuilder.CreateTable(
                name: "Categoria",
                columns: table => new
                {
                    IdCategoria = table.Column<int>(type: "INTEGER", nullable: false)
                        .Annotation("Sqlite:Autoincrement", true),
                    nombre = table.Column<string>(type: "TEXT", nullable: false),
                    descripcion = table.Column<string>(type: "TEXT", nullable: false),
                    estatus = table.Column<int>(type: "INTEGER", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Categoria", x => x.IdCategoria);
                });

            migrationBuilder.CreateTable(
                name: "Proveedor",
                columns: table => new
                {
                    IdProveedor = table.Column<int>(type: "INTEGER", nullable: false)
                        .Annotation("Sqlite:Autoincrement", true),
                    nombre = table.Column<string>(type: "TEXT", nullable: false),
                    razonSocial = table.Column<string>(type: "TEXT", nullable: false),
                    direccion = table.Column<string>(type: "TEXT", nullable: false),
                    telefono = table.Column<string>(type: "TEXT", nullable: false),
                    rfc = table.Column<string>(type: "TEXT", nullable: false),
                    correo = table.Column<string>(type: "TEXT", nullable: false),
                    estatus = table.Column<int>(type: "INTEGER", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Proveedor", x => x.IdProveedor);
                });

            migrationBuilder.CreateTable(
                name: "Usuario",
                columns: table => new
                {
                    IdUsuario = table.Column<int>(type: "INTEGER", nullable: false)
                        .Annotation("Sqlite:Autoincrement", true),
                    nombre = table.Column<string>(type: "TEXT", nullable: false),
                    correo = table.Column<string>(type: "TEXT", nullable: false),
                    contrasena = table.Column<string>(type: "TEXT", nullable: false),
                    estatus = table.Column<int>(type: "INTEGER", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Usuario", x => x.IdUsuario);
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Articulo");

            migrationBuilder.DropTable(
                name: "Categoria");

            migrationBuilder.DropTable(
                name: "Proveedor");

            migrationBuilder.DropTable(
                name: "Usuario");
        }
    }
}
