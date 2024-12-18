const generadores = [
  generadorDeMonedas, // suman puntos
  generadorDeMosquitos, // restan puntos
  generadorDeLobos, // termina el juego
  generadorDeEscudos, // inmunidad
  generadorDeAlas, // doble salto
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

class AvisoHabilidad inherits Aviso{
  method duracion() = 0
}

object avisoDobleSalto inherits AvisoHabilidad{
  override method duracion() = dobleSalto.duracion()
  override method text() = "TENES DOBLE SALTO POR " + self.duracion().div(1000).toString() + " SEGUNDOS"
}

object avisoInmunidad inherits AvisoHabilidad{
  override method duracion() = inmune.duracion()
  override method text() = "TENES INMUNIDAD POR " + self.duracion().div(1000).toString() + " SEGUNDOS"
}

object puntos{
  method position() = game.at(2,17)

  method text() = "PUNTUACION: " + dinosaurio.puntos().toString()

  method textColor() = paleta.amarillo()
}

object juegoDeDinosaurio {
  method iniciar() {
    const musiquita = game.sound("musiquita.mp3")
    musiquita.shouldLoop(true)
    musiquita.volume(0.1)
    game.schedule(500, {musiquita.play()})
    keyboard.p().onPressDo({musiquita.pause()})
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

  method duracion() = 7000

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

  method duracion() = 7000

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
  var property image = "conejito.png"
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
    if(self.puntos()<0)
    self.perder()
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

object generadorDeMosquitos inherits Generador {
  override method generar() {
    self.apareceYMovete(new Mosquito(image = "mosquito.png"))
  }
}

object generadorDeLobos inherits Generador {
  override method generar() {
    self.apareceYMovete(new Lobo(image = "lobo1.png"))
  }
}

object generadorDeEscudos inherits Generador {
  override method generar() {
    self.apareceYMovete(new Escudo(image = "escudo1.png"))
  }
}

object generadorDeAlas inherits Generador {
  override method generar() {
    self.apareceYMovete(new Alas(image = "alas3.png"))
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

class Mosquito inherits Obstaculo {
  override method teChocoElDino() {
    dinosaurio.restarPtos(4)
    game.sound("golpeMosquito.mp3").play()
  }
}

class Lobo inherits Obstaculo {
  override method teChocoElDino() {
    dinosaurio.perder()
  }
}

class Escudo inherits Obstaculo {
  override method teChocoElDino() {
    dinosaurio.cambiarEstadoPorUnosSeg(inmune.duracion(), inmune)
    inmune.avisaAlUsuario()
    game.sound("buff.mp3").play()

  }
}

class Alas inherits Obstaculo {
  override method teChocoElDino() {
    dinosaurio.cambiarEstadoPorUnosSeg(dobleSalto.duracion(), dobleSalto)
    dobleSalto.avisaAlUsuario()
    game.sound("alasBuff.mp3").play()
  }
}
