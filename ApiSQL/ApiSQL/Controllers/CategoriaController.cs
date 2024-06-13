using ApiSQL.Data;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace ApiSQL.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CategoriaController : ControllerBase
    {
        private readonly DataContext _context;

        public CategoriaController(DataContext context)
        {
            _context = context;
        }
        [HttpPost]
        public async Task<ActionResult<List<Categoria>>> AddCharacter(Categoria categoria)
        {
            _context.Categoria.Add(categoria);
            await _context.SaveChangesAsync();

            return Ok(await _context.Categoria.ToListAsync());
        }
        [HttpGet]
        public async Task<ActionResult<List<Categoria>>> GetAllCaracters()
        {
            return Ok(await _context.Categoria.ToListAsync());
        }
        [HttpGet("{id}")]
        public async Task<ActionResult<Categoria>> GetCharacter(int id)
        {
            var categoria = await _context.Categoria.FindAsync(id);
            if (categoria == null)
            {
                return BadRequest("Categoria no encontrado");
            }
            return Ok(categoria);
        }
        [HttpPut("{id}")]
        public async Task<ActionResult<Categoria>> UpdateCategoria(int id, Categoria categoria)
        {
            var categoriaToUpdate = await _context.Categoria.FindAsync(id);
            if (categoriaToUpdate == null)
            {
                return NotFound("Categoría no encontrada");
            }

            // Actualizar propiedades de la categoría
            categoriaToUpdate.nombre = categoria.nombre;
            categoriaToUpdate.descripcion = categoria.descripcion;
            categoriaToUpdate.estatus = categoria.estatus;

            // Agrega más propiedades que desees actualizar

            _context.Categoria.Update(categoriaToUpdate);
            await _context.SaveChangesAsync();

            return Ok(categoriaToUpdate);
        }
        [HttpPut("inactivar/{id}")]
        public async Task<ActionResult> InactivarCategoria(int id)
        {
            var categoria = await _context.Categoria.FindAsync(id);
            if (categoria == null)
            {
                return NotFound("Proveedor no encontrado");
            }

            categoria.estatus = 0; 

            _context.Categoria.Update(categoria);
            await _context.SaveChangesAsync();

            return Ok("Categoria inactivado correctamente");
        }
    }
}
