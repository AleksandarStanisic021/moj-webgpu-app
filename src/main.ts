// @ts-ignore
import "./style.css";

import { init } from "./init";

const shaderCode = await fetch(
  new URL("./shader/shader.wgsl", import.meta.url),
).then(async (response) => {
  if (!response.ok) {
    throw new Error(
      `Failed to load shader: ${response.status} ${response.statusText}`,
    );
  }
  return response.text();
});

init().catch((error) => {
  console.error("Greška prilikom inicijalizacije WebGPU-a:", error);
});

async function Run() {
  console.log("Pokrećem render loop...");
  const { device, context, format, adapter } = await init();

  const pipeline: GPURenderPipeline = device.createRenderPipeline({
    layout: "auto",
    vertex: {
      module: device.createShaderModule({
        code: shaderCode,
      }),
      entryPoint: "vs_main",
    },

    fragment: {
      module: device.createShaderModule({
        code: shaderCode,
      }),
      entryPoint: "fs_main",
      targets: [{ format }],
    },
    primitive: {
      topology: "triangle-list",
    },
  });

  const commandEncoder = device.createCommandEncoder();
  const textureView = context.getCurrentTexture().createView();

  const renderPass = commandEncoder.beginRenderPass({
    colorAttachments: [
      {
        view: textureView,
        clearValue: { r: 0.0, g: 0.0, b: 0.0, a: 1.0 },
        loadOp: "clear",
        storeOp: "store",
      },
    ],
  });
  renderPass.setPipeline(pipeline);
  renderPass.draw(3, 1, 0, 0);
  renderPass.end();
  device.queue.submit([commandEncoder.finish()]);
}

Run().catch((error) => {
  console.error("Greška prilikom pokretanja render loop-a:", error);
});
