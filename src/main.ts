import "./style.css";
import { init } from "./init";
import Dog from "./dog";
import Car from "./car";

const myDog = new Dog("Rex");
myDog.bark();

const myCar = new Car("Toyota", "Camry", 2020);
console.log(`${myCar.year} ${myCar.make} ${myCar.model}`);

init().catch((error) => {
  console.error("Greška prilikom inicijalizacije WebGPU-a:", error);
});
