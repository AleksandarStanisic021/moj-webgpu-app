// @ts-ignore
import "./style.css";
import { init } from "./init";
import shader from "./shader.wgsl";

init().catch((error) => {
  console.error("Greška prilikom inicijalizacije WebGPU-a:", error);
});

const { device, context, format, adapter } = await init();

const pipeline: GPURenderPipeline = device.createRenderPipeline({});

console.log(device, context, format, adapter);
