function Navbar() {
  return (
    <nav className="rounded-xl w-[250px] min-h-[880px] bg-teal-700 text-white sticky top-0 p-4 m-4">
      {/* Logo o título */}
      <h2 className="text-xl font-bold mb-8">Despacho Dashboard</h2>
      <p className="text-sm text-teal-100 mb-8">Demo CI/CD — Innovatech Chile</p>

      {/* Menú de navegación */}
      <ul className="space-y-3">
        <li>
          <a
            href="#"
            className="block font-bold py-2 px-3 hover:bg-teal-800 rounded"
          >
            Usuarios
          </a>
        </li>
        <li>
          <a
            href="#"
            className="block font-bold py-2 px-3 hover:bg-teal-800 rounded"
          >
            Productos
          </a>
        </li>
        <li>
          <a
            href="#"
            className="block font-bold py-2 px-3 hover:bg-teal-800 rounded"
          >
            Configuración
          </a>
        </li>
        <li className="pt-4 mt-4 border-t border-white/20">
          <span className="block text-sm font-semibold px-3 text-teal-100">
            Integraciones
          </span>
        </li>
      </ul>
    </nav>
  );
}

export default Navbar;
