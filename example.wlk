const generadores = [
  generadorDeMonedas,
  generadorDePeras,
  generadorDeBananas,
  generadorDeNada
]

object juegoDeDinosaurio {
  method iniciar() {
    game.width(45)
    game.height(20)
    game.addVisual(dinosaurio)
    
    game.onTick(1000, "aparecerObjeto", { generadores.anyOne().generar() })
    
    keyboard.up().onPressDo({ dinosaurio.salta() })
    
    game.whenCollideDo(dinosaurio, { elemento => elemento.teChocoElDino() })
  }
}

object dinosaurio {
  var property position = game.origin()
  var property image = "manzana.png"
  
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
  
  method sumarPtos() {
    
  }
  
  method restarPtos() {
    
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

class Obstaculo {
  var property position = game.at(game.width(), self.posY())
  var property image
  
  const valores = [0,4,12,16]
  
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
    dinosaurio.restarPtos()
  }
}

class Banana inherits Obstaculo {
  override method teChocoElDino() {
    dinosaurio.terminarJuego()
  }
}
