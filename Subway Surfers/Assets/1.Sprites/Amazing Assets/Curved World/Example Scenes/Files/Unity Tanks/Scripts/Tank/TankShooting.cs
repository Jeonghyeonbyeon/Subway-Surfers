﻿using UnityEngine;
using UnityEngine.UI;

#if ENABLE_INPUT_SYSTEM
    using UnityEngine.InputSystem;
#endif


namespace AmazingAssets.CurvedWorld.Example
{
    public class TankShooting : MonoBehaviour
    {
        TankMovement tankMovement;
        public Rigidbody m_Shell;                   // Prefab of the shell.
        public Transform m_FireTransform;           // A child of the tank where the shells are spawned.
        public Slider m_AimSlider;                  // A child of the tank that displays the current launch force.
        public AudioSource m_ShootingAudio;         // Reference to the audio source used to play the shooting audio. NB: different to the movement audio source.
        public AudioClip m_FireClip;                // Audio that plays when each shot is fired.
        public float m_MinLaunchForce = 15f;        // The force given to the shell if the fire button is not held.
        public float m_MaxLaunchForce = 30f;        // The force given to the shell if the fire button is held for the max charge time.
        public float m_MaxChargeTime = 0.75f;       // How long the shell can charge for before it is fired at max force.


        private float m_CurrentLaunchForce;         // The force that will be given to the shell when the fire button is released.
        private float m_ChargeSpeed;                // How fast the launch force increases, based on the max charge time.
        private bool m_Fired;                       // Whether or not the shell has been launched with this button press.


        private void OnEnable()
        {
            // When the tank is turned on, reset the launch force and the UI
            m_CurrentLaunchForce = m_MinLaunchForce;
            m_AimSlider.value = m_MinLaunchForce;
        }


        private void Start ()
        {
            tankMovement = GetComponent<TankMovement>();

            // The rate that the launch force charges up is the range of possible forces by the max charge time.
            m_ChargeSpeed = (m_MaxLaunchForce - m_MinLaunchForce) / m_MaxChargeTime;
        }


        private void Update ()
        {
            // The slider should have a default value of the minimum launch force.
            m_AimSlider.value = m_MinLaunchForce;

#if ENABLE_INPUT_SYSTEM
            Key shootingKeyCode = tankMovement.playerID == 2 ? Key.RightCtrl : Key.Space;
#else
            KeyCode shootingKeyCode = tankMovement.playerID == 2 ? KeyCode.RightControl : KeyCode.Space;
#endif

            // If the max force has been exceeded and the shell hasn't yet been launched...
            if (m_CurrentLaunchForce >= m_MaxLaunchForce && !m_Fired)
            {
                // ... use the max force and launch the shell.
                m_CurrentLaunchForce = m_MaxLaunchForce;
                Fire ();
            }
            // Otherwise, if the fire button has just started being pressed...
            else if (ExampleInput.GetKeyDown(shootingKeyCode))
            {
                // ... reset the fired flag and reset the launch force.
                m_Fired = false;
                m_CurrentLaunchForce = m_MinLaunchForce;
            }
            // Otherwise, if the fire button is being held and the shell hasn't been launched yet...
            else if (ExampleInput.GetKey(shootingKeyCode) && !m_Fired)
            {
                // Increment the launch force and update the slider.
                m_CurrentLaunchForce += m_ChargeSpeed * Time.deltaTime;

                m_AimSlider.value = m_CurrentLaunchForce;
            }
            // Otherwise, if the fire button is released and the shell hasn't been launched yet...
            else if (ExampleInput.GetKeyUp(shootingKeyCode) && !m_Fired)
            {
                // ... launch the shell.
                Fire ();
            }
        }


        private void Fire ()
        {
            // Set the fired flag so only Fire is only called once.
            m_Fired = true;

            // Create an instance of the shell and store a reference to it's rigidbody.
            Rigidbody shellInstance = Instantiate (m_Shell, m_FireTransform.position, m_FireTransform.rotation) as Rigidbody;

            shellInstance.gameObject.SetActive(true);

            // Set the shell's velocity to the launch force in the fire position's forward direction.
            shellInstance.velocity = m_CurrentLaunchForce * m_FireTransform.forward; 

            // Change the clip to the firing clip and play it.
            m_ShootingAudio.clip = m_FireClip;
            m_ShootingAudio.Play ();

            // Reset the launch force.  This is a precaution in case of missing button events.
            m_CurrentLaunchForce = m_MinLaunchForce;
        }
    }
}