import Felgo 3.0
import QtQuick 2.0

GameWindow {
    id: gameWindow

    Scene {
        id: scene

        Particle {
            id: fireParticle

            // Particle location properties
            x: scene.width/2
            y: scene.height/2
            sourcePositionVariance: Qt.point(0,0)

            // Particle configuration properties
            maxParticles: 38
            particleLifespan: 0.9
            particleLifespanVariance: 0.2
            startParticleSize: 7
            startParticleSizeVariance: 2
            finishParticleSize: 45
            finishParticleSizeVariance: 10
            rotation: 0
            angleVariance: 0
            rotationStart: 0
            rotationStartVariance: 0
            rotationEnd: 0
            rotationEndVariance: 0

            // Emitter Behavior
            emitterType: 0
            duration: 0
            positionType: 1

            // Gravity Mode (Gravity + Tangential Accel + Radial Accel)
            gravity: Qt.point(0,0)
            speed: 85
            speedVariance: 2
            tangentialAcceleration: 0
            tangentialAccelVariance: 0
            radialAcceleration: 0
            radialAccelVariance: 0

            // Radiation Mode (circular movement)
            minRadius: 0
            minRadiusVariance: 0
            maxRadius: 0
            maxRadiusVariance: 0
            rotatePerSecond: 0
            rotatePerSecondVariance: 0

            // Appearance
            startColor: Qt.rgba(0.76, 0.25, 0.12, 1)
            startColorVariance: Qt.rgba(0, 0, 0, 0)
            finishColor: Qt.rgba(0, 0, 0, 1)
            finishColorVariance: Qt.rgba(0,0,0,0)
            textureFileName: "particleFire.png"


            // start when finished loading
            autoStart: true
        }


        MouseArea {
            anchors.fill: parent

            onClicked: {
                // position the fire particle emitter (=origin) to the position of the mouse
                fireParticle.x = mouseX
                fireParticle.y = mouseY

                // this rotates the fire particle direction 45 degrees clockwise with every click
                fireParticle.rotation += 45

            }

            onPositionChanged: {
                // while the mouse is pressed (=dragged), also change the position
                fireParticle.x = mouseX
                fireParticle.y = mouseY
            }
        }

    } // end of Scene

} // end of GameWindow
