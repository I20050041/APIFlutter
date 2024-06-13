using System.ComponentModel.DataAnnotations;

namespace ApiSQL
{
    public class Articulo
    {
        [Key] public int IdArticulos { get; set; }
        public string nombre { get; set; }
        public string descripcion { get; set; }
        public decimal precioUnitario { get; set; }
        public int stock { get; set; }
        public int estatus { get; set; }


    }
}
