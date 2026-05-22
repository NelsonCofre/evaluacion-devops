import { defineConfig, loadEnv } from "vite";
import react from "@vitejs/plugin-react-swc";

export default defineConfig(({ mode }) => {
  const env = loadEnv(mode, process.cwd(), "");
  return {
    plugins: [react()],
    server: {
      port: 3000,
      proxy: {
        "/api/v1/ventas": {
          target: env.VITE_VENTAS_API_URL || "http://localhost:8081",
          changeOrigin: true,
        },
        "/api/v1/despachos": {
          target: env.VITE_DESPACHO_API_URL || "http://localhost:8082",
          changeOrigin: true,
        },
      },
    },
  };
});
