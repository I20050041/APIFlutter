using System.ComponentModel.DataAnnotations;

namespace ApiSQL
{
    public class Usuario
    {
        [Key] public int IdUsuario { get; set; }
        public string nombre { get; set; }
        public string correo { get; set; }
        public string contrasena { get; set; }
        public int estatus { get; set; }

    }
}
