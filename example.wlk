const generadores = [
  generadorDeMonedas, // suman puntos
  generadorDePeras, // restan puntos
  generadorDeBananas, // termina el juego
  generadorDeFrutillas, // inmunidad
  generadorDeUvas, // doble salto
  generadorDeNada
]

object paleta {
  const property amarillo = "FFFF00FF"

  const property blanco = "FFFFFFFF"
}

class Aviso{
  method position() = game.at(22,16)

  method text()

  method textColor() = paleta.blanco()
}

object avisoDobleSalto inherits Aviso{
  override method text() = "TENES DOBLE SALTO POR 5 SEGUNDOS"
}

object avisoInmunidad inherits Aviso{
  override method text() = "TENES INMUNIDAD POR 8 SEGUNDOS"
}

object puntos{
   method position() = game.at(2,17)

   method text() = "PUNTUACION: " + dinosaurio.puntos().toString()

   method textColor() = paleta.amarillo()
}

object juegoDeDinosaurio {
  method iniciar() {
    game.width(45)
    game.height(20)
    game.addVisual(dinosaurio)
    game.addVisual(puntos)
    game.boardGround("bosque.png")
    game.onTick(1000, "aparecerObjeto", { generadores.anyOne().generar() })
    keyboard.up().onPressDo({ dinosaurio.saltar() })
    game.whenCollideDo(dinosaurio, { elemento => elemento.teChocoElDino() })
  }
}

object normal {
  method puntosRestados(n) = n
  
  method puntosSumados(n) = n
  
  method terminarJuego() {
    dinosaurio.detenerJuego()
  }
  
  method salto() {
    if (dinosaurio.position() == game.origin()) dinosaurio.hacerSalto()
  }
}

object dobleSalto {
  method avisaAlUsuario() {
    game.addVisual(avisoDobleSalto)
    game.schedule(2500, {game.removeVisual(avisoDobleSalto)})
  }

  method puntosRestados(n) = n
  
  method puntosSumados(n) = n
  
  method terminarJuego() {
    dinosaurio.detenerJuego()
  }
  
  method salto() {
    if ((dinosaurio.position() == game.origin()) || (dinosaurio.position() == game.at(0,4))) 
    dinosaurio.hacerSalto()
  }
}

object inmune {
  method avisaAlUsuario() {game.addVisual(avisoInmunidad)
  game.schedule(2500, {game.removeVisual(avisoInmunidad)})
  }

  method puntosRestados(_) = 0
  
  method puntosSumados(n) = n
  
  method terminarJuego() {
    
  }
  
  method salto() {
    if (dinosaurio.position() == game.origin()) {
      dinosaurio.hacerSalto()
      // Si el dino salta mientras que está inmune, pierde la inmunidad.
      dinosaurio.estado(normal)
    }
  }
}

object dinosaurio {
  var property position = game.origin()
  var property image = "manzana.png"
  var property puntos = 0
  var property estado = normal
  
  method saltar() {
    estado.salto()
    game.sound("saltoDino.mp3").play()
  }
  
  method hacerSalto() {
    self.subir()
    game.schedule(600, { self.bajar() })
  }
  
  method bajar() {
    position = game.origin()
  }
  
  method subir() {
    position = position.up(4)
  }
  
  method sumarPtos(n) {
    puntos += estado.puntosSumados(n)
  }
  
  method restarPtos(n) {
    puntos -= estado.puntosRestados(n)
  }
  
  method perder() {
    estado.terminarJuego()
  }

  method detenerJuego() {
    game.stop()
  }
  
  method cambiarEstadoPorUnosSeg(n, nuevoEstado) {
    estado = nuevoEstado
    // luego de n milisegundos el estado vuelve a ser normal
    game.schedule(n, {estado = normal} )
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

object generadorDeFrutillas inherits Generador {
  override method generar() {
    self.apareceYMovete(new Frutilla(image = "frutilla2.png"))
  }
}

object generadorDeUvas inherits Generador {
  override method generar() {
    self.apareceYMovete(new Uvas(image = "uvas.png"))
  }
}

object generadorDeNada {
  method generar() {
    
  }
}

class Obstaculo {
  var property position = game.at(game.width()-1, self.posY())
  var property image
  const valores = [0, 4, 8]
  
  method posY() = valores.anyOne()
  
  method teChocoElDino()
  
  method desplazate() {
    position = position.left(2)
  }
}

class Moneda inherits Obstaculo {
  override method teChocoElDino() {
    dinosaurio.sumarPtos(8)
    game.sound("dinoCoin.mp3").play()
  }
}

class Pera inherits Obstaculo {
  override method teChocoElDino() {
    dinosaurio.restarPtos(4)
  }
}

class Banana inherits Obstaculo {
  override method teChocoElDino() {
    dinosaurio.perder()
  }
}

class Frutilla inherits Obstaculo {
  override method teChocoElDino() {
    dinosaurio.cambiarEstadoPorUnosSeg(8000, inmune)
    inmune.avisaAlUsuario()
  }
}

class Uvas inherits Obstaculo {
  override method teChocoElDino() {
    dinosaurio.cambiarEstadoPorUnosSeg(5000, dobleSalto)
    dobleSalto.avisaAlUsuario()
  }
}
