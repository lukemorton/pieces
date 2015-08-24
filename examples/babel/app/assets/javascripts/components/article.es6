class Hello {
  world() {
    console.log('hello world!!')
  }
}

(new Hello).world()

window.onload = function () {
  console.log('page has loaded')
}


window.onload = () => {
  console.log('page has loaded with arrow syntax!!')
  console.log('multi line')
}

