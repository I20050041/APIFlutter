using System.ComponentModel.DataAnnotations;

namespace ApiSQL
{
    public class Proveedor
    {
        [Key] public int IdProveedor { get; set; }
        public string nombre { get; set; }
        public string razonSocial { get; set; }
        public string direccion { get; set; }
        public string telefono { get; set; }
        public string rfc { get; set; }
        public string correo { get; set; }
        public int estatus { get; set; }
    }
}
