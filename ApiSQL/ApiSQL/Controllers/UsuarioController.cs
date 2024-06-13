using ApiSQL.Data;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace ApiSQL.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UsuarioController : ControllerBase
    {
        private readonly DataContext _context;

        public UsuarioController(DataContext context)
        {
            _context = context;
        }
        [HttpPost]
        public async Task<ActionResult<List<Usuario>>> AddCharacter(Usuario usuario)
        {
            _context.Usuario.Add(usuario);
            await _context.SaveChangesAsync();

            return Ok(await _context.Usuario.ToListAsync());
        }
        [HttpGet]
        public async Task<ActionResult<List<Usuario>>> GetAllCaracters()
        {
            return Ok(await _context.Usuario.ToListAsync());
        }
        [HttpGet("{id}")]
        public async Task<ActionResult<Usuario>> GetCharacter(int id)
        {
            var usuario = await _context.Usuario.FindAsync(id);
            if (usuario == null)
            {
                return BadRequest("Usuario no encontrado");
            }
            return Ok(usuario);
        }
        [HttpPut("{id}")]
        public async Task<ActionResult<Categoria>> UpdateUsuario(int id, Usuario usuario)
        {
            var usuarioToUpdate = await _context.Usuario.FindAsync(id);
            if (usuarioToUpdate == null)
            {
                return NotFound("Usuario no encontrada");
            }

            // Actualizar propiedades de la categoría
            usuarioToUpdate.nombre = usuario.nombre;
            usuarioToUpdate.correo = usuario.correo;
            usuarioToUpdate.contrasena = usuario.contrasena;
            usuarioToUpdate.estatus = usuario.estatus;

            // Agrega más propiedades que desees actualizar

            _context.Usuario.Update(usuarioToUpdate);
            await _context.SaveChangesAsync();

            return Ok(usuarioToUpdate);
        }
        [HttpPut("inactivar/{id}")]
        public async Task<ActionResult> InactivarUsuario(int id)
        {
            var usuario = await _context.Usuario.FindAsync(id);
            if (usuario == null)
            {
                return NotFound("Usuario no encontrado");
            }

            usuario.estatus = 0;

            _context.Usuario.Update(usuario);
            await _context.SaveChangesAsync();

            return Ok("Usuario inactivado correctamente");
        }
        [HttpGet("autenticar")]
        public async Task<ActionResult> AutenticarUsuario(string correo, string contrasena)
        {
            var usuario = await _context.Usuario.FirstOrDefaultAsync(u => u.correo == correo && u.contrasena == contrasena && u.estatus == 1);
            if (usuario == null)
            {
                return BadRequest("Credenciales incorrectas");
            }
            else
            {
                // Aquí podrías generar un token JWT si deseas implementar autenticación basada en tokens
                return Ok("Credenciales correctas");
            }
        }
    }
}
