using System.ComponentModel.DataAnnotations;

namespace ApiSQL
{
    public class Categoria
    {
        [Key] public int IdCategoria { get; set; }
        public string nombre { get; set; }
        public string descripcion { get; set; }
        public int estatus { get; set; }

    }
}
