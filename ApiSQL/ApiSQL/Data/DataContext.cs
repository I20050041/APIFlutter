using Microsoft.EntityFrameworkCore;

namespace ApiSQL.Data
{
    public class DataContext : DbContext
    {
        public DataContext(DbContextOptions<DataContext> options) : base(options) { 
        
        }
        public DbSet<Articulo> Articulo => Set<Articulo>();
        public DbSet<Proveedor> Proveedor => Set<Proveedor>();
        public DbSet<Categoria> Categoria => Set<Categoria>();
        public DbSet<Usuario> Usuario => Set<Usuario>();

    }
}
