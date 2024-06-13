using ApiSQL.Data;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;


namespace ApiSQL.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ProveedorController : ControllerBase
    {
        private readonly DataContext _context;

        public ProveedorController(DataContext context)
        {
            _context = context;
        }
        [HttpPost]
        public async Task<ActionResult<List<Proveedor>>> AddCharacter(Proveedor proveedor)
        {
            _context.Proveedor.Add(proveedor);
            await _context.SaveChangesAsync();

            return Ok(await _context.Proveedor.ToListAsync());
        }
        [HttpGet]
        public async Task<ActionResult<List<Proveedor>>> GetAllCaracters()
        {
            return Ok(await _context.Proveedor.ToListAsync());
        }
        [HttpGet("{id}")]
        public async Task<ActionResult<Proveedor>> GetCharacter(int id)
        {
            var proveedor = await _context.Proveedor.FindAsync(id);
            if (proveedor == null)
            {
                return BadRequest("Proveedor no encontrado");
            }
            return Ok(proveedor);
        }
        [HttpPut("{id}")]
        public async Task<ActionResult<Proveedor>> UpdateProveedor(int id, Proveedor proveedor)
        {
            var proveedorToUpdate = await _context.Proveedor.FindAsync(id);
            if (proveedorToUpdate == null)
            {
                return NotFound("Proveedor no encontrado");
            }

            // Actualizar propiedades del proveedor
            proveedorToUpdate.nombre = proveedor.nombre;
            proveedorToUpdate.razonSocial = proveedor.razonSocial;
            proveedorToUpdate.direccion = proveedor.direccion;
            proveedorToUpdate.telefono = proveedor.telefono;
            proveedorToUpdate.rfc = proveedor.rfc;
            proveedorToUpdate.correo = proveedor.correo;
            proveedorToUpdate.estatus = proveedor.estatus;

            // Agrega más propiedades que desees actualizar

            _context.Proveedor.Update(proveedorToUpdate);
            await _context.SaveChangesAsync();

            return Ok(proveedorToUpdate);
        }
        [HttpPut("inactivar/{id}")]
        public async Task<ActionResult> InactivarProveedor(int id)
        {
            var proveedor = await _context.Proveedor.FindAsync(id);
            if (proveedor == null)
            {
                return NotFound("Proveedor no encontrado");
            }

            proveedor.estatus = 0; // Establecer el estado a inactivo (o cualquier otro valor que represente inactivo)

            _context.Proveedor.Update(proveedor);
            await _context.SaveChangesAsync();

            return Ok("Proveedor inactivado correctamente");
        }
    }
}
