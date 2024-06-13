using ApiSQL.Data;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace ApiSQL.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ArticulosController : ControllerBase
    {
        private readonly DataContext _context;

        public ArticulosController(DataContext context)
        {
            _context = context;
        }
        [HttpPost]
        public async Task <ActionResult<List<Articulo>>> AddCharacter(Articulo articulo)
        {
            _context.Articulo.Add(articulo);
            await _context.SaveChangesAsync();

            return Ok(await _context.Articulo.ToListAsync());
        }
        [HttpGet]
        public async Task<ActionResult<List<Articulo>>> GetAllCaracters()
        {
            return Ok(await _context.Articulo.ToListAsync());
        }
        [HttpGet("{id}")]
        public async Task<ActionResult<Articulo>> GetCharacter(int id)
        {
            var articulo = await _context.Articulo.FindAsync(id);
            if(articulo == null)
            {
                return BadRequest("articulo no encontrado");
            }
            return Ok(articulo);
        }
        [HttpPut("{id}")]
        public async Task<ActionResult<Articulo>> UpdateArticulo(int id, Articulo articulo)
        {
            var articuloToUpdate = await _context.Articulo.FindAsync(id);
            if (articuloToUpdate == null)
            {
                return NotFound("Artículo no encontrado");
            }
            articuloToUpdate.nombre = articulo.nombre;
            articuloToUpdate.descripcion = articulo.descripcion;
            articuloToUpdate.precioUnitario = articulo.precioUnitario;
            articuloToUpdate.stock = articulo.stock;
            articuloToUpdate.estatus = articulo.estatus;
            
            _context.Articulo.Update(articuloToUpdate);
            await _context.SaveChangesAsync();

            return Ok(articuloToUpdate);
        }
        [HttpPut("inactivar/{id}")]
        public async Task<ActionResult> InactivarArticulo(int id)
        {
            var articulo = await _context.Articulo.FindAsync(id);
            if (articulo == null)
            {
                return NotFound("Artículo no encontrado");
            }

            articulo.estatus = 0;

            _context.Articulo.Update(articulo);
            await _context.SaveChangesAsync();

            return Ok("Artículo inactivado correctamente");
        }
    }
}
