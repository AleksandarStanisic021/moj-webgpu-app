import "./style.css";
import { init } from "./init";

console.log("yoyo");

init().catch((error) => {
  console.error("Greška prilikom inicijalizacije WebGPU-a:", error);
});
