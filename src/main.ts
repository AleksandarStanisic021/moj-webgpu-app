// @ts-ignore
import "./style.css";
import { init } from "./init";

init().catch((error) => {
  console.error("Greška prilikom inicijalizacije WebGPU-a:", error);
});

const { device, context, format, adapter } = await init();
console.log(device, context, format, adapter);
