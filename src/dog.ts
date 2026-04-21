class Dog {
  name: string;
  constructor(name: string) {
    this.name = name;
  }
  bark() {
    console.log(`${this.name} says: Woof!`);
  }
}
export default Dog;
