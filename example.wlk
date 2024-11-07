const generadores = [
  generadorDeMonedas,
  generadorDePeras,
  generadorDeBananas,
  generadorDeNada,
  generadorDeFrutillas
]

object juegoDeDinosaurio {
  method iniciar() {
    game.width(45)
    game.height(20)
    game.addVisual(dinosaurio)
    
    game.boardGround("fondoBosque.jpg")

    game.onTick(1000, "aparecerObjeto", { generadores.anyOne().generar() })
    
    keyboard.up().onPressDo({ dinosaurio.salta() })

    keyboard.down().onPressDo({ dinosaurio.powerUP() })
    
    game.whenCollideDo(dinosaurio, { elemento => elemento.teChocoElDino() })
  }
}

// VER ESTO o HACER ESTO
object normal{
  method salta() {
    if (dinosaurio.puedeSaltar()) {
      dinosaurio.subir()
      game.schedule(450, { dinosaurio.bajar() })
    }
  }
}
//IDEM
object inmune {
  method inmune(){
    dinosaurio.perderInmunidad()
  }
}

object dinosaurio {
  var property position = game.origin()
  var property image = "Carpincho.png"
  var estado = normal  // ver esto

  method salta() {
    estado.salta()
  }

  method recibirDanio(){
    estado.recibirDanio()
  }
  
  method bajar() {
    position = game.origin()
  }
  
  method subir() {
    position = position.up(4)
  }

  method powerUP()
  {
    if (position == game.origin())
    {
      self.saltoDoble()
      game.schedule(225,{self.bajar()})
    }
  }
  
  method saltoDoble()
  {
    position = position.up(8)
  }

  method sumarPtos() {
    
  }
  
  method restarPtos() {
    
  }

  method powerupInmunidad() {
    inmunidad = 1
    game.schedule(500, {inmunidad = 0})
  }
  
  method terminarJuego() {
    game.stop()
  }
}

class Generador {
  method generar()
  
  method apareceYMovete(nuevoObstaculo) {
    game.addVisual(nuevoObstaculo)
    game.onTick(120, "desplazamiento", { nuevoObstaculo.desplazate() })
  }
}

object generadorDeMonedas inherits Generador {
  override method generar() {
    self.apareceYMovete(new Moneda(image = "moneda.png"))
  }
}

object generadorDePeras inherits Generador {
  override method generar() {
    self.apareceYMovete(new Pera(image = "pera.png"))
  }
}

object generadorDeBananas inherits Generador {
  override method generar() {
    self.apareceYMovete(new Banana(image = "banana.png"))
  }
}

object generadorDeNada {
  method generar() {

  }
}

// Powerup de Inmunidad
object generadorDeFrutillas inherits Generador {
  override method generar() {
    self.apareceYMovete(new Frutilla(image = "frutilla.png"))
  }
}

class Obstaculo {
  var property position = game.at(game.width(), self.posY())
  var property image
  
  const valores = [3,7]
  
  method posY() = valores.anyOne()
  
  method teChocoElDino()
  
  method desplazate() {
    position = position.left(2)
  }
}

class Moneda inherits Obstaculo {
  override method teChocoElDino() {
    dinosaurio.sumarPtos()
  }
}

class Pera inherits Obstaculo {
  override method teChocoElDino() {
    if(dinosaurio.inmunidad != 1)
    {
      dinosaurio.restarPtos()
    }
  }
}

class Banana inherits Obstaculo {
  override method teChocoElDino() {
    if(dinosaurio.inmunidad != 1)
    {
      dinosaurio.terminarJuego()
    }
  }
}

// Powerup de Inmunidad
class Frutilla inherits Obstaculo{
  override method teChocoElDino() {
    dinosaurio.powerupInmunidad()
  }
}
