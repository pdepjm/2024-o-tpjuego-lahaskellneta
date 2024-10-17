const velocidad = 100

object juegoDeDinosaurio {
  method iniciar() {
    game.addVisual(dinosaurio)
    game.addVisual(cactus1)
    game.addVisual(cactus2)
    game.addVisual(moneda)
    game.onTick(velocidad, "moverCactus1", {cactus1.desplazate()})
    game.onTick(velocidad, "moverCactus2", {cactus2.desplazate()})
    game.onTick(velocidad, "moverMoneda", {moneda.desplazate()})

    // Apenas el dinosaurio colisione con un cactus, el juego termina
    game.whenCollideDo(dinosaurio, {elemento => elemento.teChocoElDino()})

    // con la tecla up el dinosaurio salta
    keyboard.up().onPressDo{dinosaurio.salta()}

    game.width(45)
    game.height(20)
  }

  method finalizar() {
    cactus1.detenete()
    cactus2.detenete()
    moneda.detenete()
    game.removeVisual(dinosaurio)
    game.removeVisual(cactus1)
    game.removeVisual(cactus2)
    game.removeVisual(moneda)
    // game.addVisual(gameOver)
  }
}

object dinosaurio {
  method image() = "manzana.png"
  var property position = game.origin()
  method salta() {
      if (position == game.origin()) {
        self.subir()
        game.schedule(450, { self.bajar() })
    }
  }

  method bajar() {
    position = game.origin()
  }
  
  method subir() {
    position = position.up(4)
  }
}

class Cactus {
  const posX
  var property position = game.at(posX,0)
  var property image
  var colisiono = false

  method teChocoElDino() {
    juegoDeDinosaurio.finalizar()
  }

  method detenete() {
    colisiono = true // de este modo, el cactus no se desplaza más
  }

  method desplazate() {
    if (not colisiono) {
      position = position.left(1)
      if (position.x() == -1) position = game.at(game.width()-1,0)
    }
  }
}

class Moneda {
  const posX
  var property position = game.at(posX,0)
  var property image
  var colisiono = false

  method teChocoElDino() {
    position = game.at(game.width()-1,0)
    // sumar puntos
  }

  method detenete() {
    colisiono = true // de este modo, el cactus no se desplaza más
  }

  method desplazate() {
    if (not colisiono) {
      position = position.left(1)
      if (position.x() == -1) position = game.at(game.width()-1,0)
    }
  }
}

const cactus1 = new Cactus(posX=19,image="banana.png")
const cactus2 = new Cactus(posX=43,image="pera.png")
const moneda = new Moneda(posX=27,image="moneda.png")

// object suelo {
//   method image() = ""
// }
// object gameOver {
//   var property position = game.at(22,10) //centro del tablero
// }
