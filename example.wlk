const velocidad = 500

object juegoDeDinosaurio {
  method iniciar() {
    game.addVisual(dinosaurio)
    game.addVisual(cactus1)
    game.addVisual(cactus2)
    game.onTick(velocidad, "moverCactus1", {cactus1.desplazate()})
    game.onTick(velocidad, "moverCactus2", {cactus2.desplazate()})

    // Apenas el dinosaurio colisione con un cactus, el juego termina
    // game.whenCollideDo(dinosaurio, {elemento => elemento.teChocoElDino()})

    // con la tecla up el dinosaurio salta
    // keyboard.up().onPressDo{dinosaurio.salta()}

    game.width(45)
    game.height(20)
  }
}

object dinosaurio {
  method image() = "manzana.png"
  var property position = game.origin()
  method salta() {
    
  }
}

class Cactus {
  const posX
  var property position = game.at(posX,0)
  var property image

  method teChocoElDino() {
    // perder
  }

  method desplazate() {
    position = position.left(1)
    // si llega al borde de la pantalla, aparece de nuevo por la derecha
    if (position.x() == -1) position = game.at(game.width()-1,0)
  }
}

const cactus1 = new Cactus(posX=19,image="banana.png")
const cactus2 = new Cactus(posX=42,image="pera.png")

// object suelo {
//   method image() = ""
// }