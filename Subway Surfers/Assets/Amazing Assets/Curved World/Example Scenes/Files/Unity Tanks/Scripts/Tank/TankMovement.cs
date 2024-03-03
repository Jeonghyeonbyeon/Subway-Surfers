using UnityEngine;

#if ENABLE_INPUT_SYSTEM
    using UnityEngine.InputSystem;
#endif


namespace AmazingAssets.CurvedWorld.Example
{
    public class TankMovement : MonoBehaviour
    {
        public int playerID = 1;
        public float m_Speed = 12f;                 // How fast the tank moves forward and back.
        public float m_TurnSpeed = 180f;            // How fast the tank turns in degrees per second.

        private Rigidbody m_Rigidbody;              // Reference used to move the tank.
        private ParticleSystem[] m_particleSystems; // References to all the particles systems used by the Tanks

        private void Awake ()
        {
            m_Rigidbody = GetComponent<Rigidbody> ();
        }


        private void OnEnable ()
        {
            // When the tank is turned on, make sure it's not kinematic.
            m_Rigidbody.isKinematic = false;
            
            // We grab all the Particle systems child of that Tank to be able to Stop/Play them on Deactivate/Activate
            // It is needed because we move the Tank when spawning it, and if the Particle System is playing while we do that
            // it "think" it move from (0,0,0) to the spawn point, creating a huge trail of smoke
            m_particleSystems = GetComponentsInChildren<ParticleSystem>();
            for (int i = 0; i < m_particleSystems.Length; ++i)
            {
                m_particleSystems[i].Play();
            }
        }


        private void OnDisable ()
        {
            // When the tank is turned off, set it to kinematic so it stops moving.
            m_Rigidbody.isKinematic = true;

            // Stop all particle system so it "reset" it's position to the actual one instead of thinking we moved when spawning
            for(int i = 0; i < m_particleSystems.Length; ++i)
            {
                m_particleSystems[i].Stop();
            }
        }

        
        private void FixedUpdate ()
        {
            // Adjust the rigidbodies position and orientation in FixedUpdate.
            Move ();
            Turn ();
        }


        private void Move ()
        {
            // Create a vector in the direction the tank is facing with a magnitude based on the input, speed and the time between frames.

            float move = 0;

#if ENABLE_INPUT_SYSTEM
            if (playerID == 1)
                move = (GetKey(Key.W) ? 1 : 0) + (GetKey(Key.S) ? -1 : 0);
            else if (playerID == 2)
                move = (GetKey(Key.UpArrow) ? 1 : 0) + (GetKey(Key.DownArrow) ? -1 : 0);
#else
            if (playerID == 1)
                move = (GetKey(KeyCode.W) ? 1 : 0) + (GetKey(KeyCode.S) ? -1 : 0);
            else if (playerID == 2)
                move = (GetKey(KeyCode.UpArrow) ? 1 : 0) + (GetKey(KeyCode.DownArrow) ? -1 : 0);
#endif


            Vector3 movement = transform.forward * move * m_Speed * Time.deltaTime;

            // Apply this movement to the rigidbody's position.
            m_Rigidbody.MovePosition(m_Rigidbody.position + movement);
        }


        private void Turn ()
        {
            // Determine the number of degrees to be turned based on the input, speed and time between frames.
            float rotation = 0;


#if ENABLE_INPUT_SYSTEM
            if (playerID == 1)
                rotation = (GetKey(Key.A) ? -1 : 0) + (GetKey(Key.D) ? 1 : 0);
            else if (playerID == 2)
                rotation = (GetKey(Key.LeftArrow) ? -1 : 0) + (GetKey(Key.RightArrow) ? 1 : 0);
#else
            if (playerID == 1)
                rotation = (GetKey(KeyCode.A) ? -1 : 0) + (GetKey(KeyCode.D) ? 1 : 0);
            else if (playerID == 2)
                rotation = (GetKey(KeyCode.LeftArrow) ? -1 : 0) + (GetKey(KeyCode.RightArrow) ? 1 : 0);
#endif


            float turn = rotation * m_TurnSpeed * Time.deltaTime;

            // Make this into a rotation in the y axis.
            Quaternion turnRotation = Quaternion.Euler (0f, turn, 0f);

            // Apply this rotation to the rigidbody's rotation.
            m_Rigidbody.MoveRotation (m_Rigidbody.rotation * turnRotation);
        }


#if ENABLE_INPUT_SYSTEM
        bool GetKey(Key key)
        {
            return Keyboard.current[key].isPressed;
        }
#else
        bool GetKey(KeyCode keyCode)
        {
            return Input.GetKey(keyCode);
        }
#endif
    }
}