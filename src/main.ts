// @ts-ignore
import "./style.css";
import { init } from "./init";

init().catch((error) => {
  console.error("Greška prilikom inicijalizacije WebGPU-a:", error);
});

const { device, context, format, adapter } = await init();

device.lost.then((event) => {
  console.error("WebGPU uređaj je izgubljen:", event);
  init().catch((error) => {
    console.error("Greška prilikom ponovne inicijalizacije WebGPU-a:", error);
  });
});

console.log(device, context, format, adapter);
