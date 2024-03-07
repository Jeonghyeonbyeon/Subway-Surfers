using System;
using UnityEngine;

#if ENABLE_INPUT_SYSTEM
using UnityEngine.InputSystem;
#endif


namespace AmazingAssets.CurvedWorld.Example
{
    [RequireComponent(typeof(Perspective2D_PlatformerCharacter))]
    public class Perspective2D_PlatformerUserControl : MonoBehaviour
    {
        private Perspective2D_PlatformerCharacter m_Character;
        private bool m_Jump;
        bool uiButtonJump;
        Vector2 touchPivot;


#if ENABLE_INPUT_SYSTEM
        Key keyJump = Key.Space;
        Key keyLeft = Key.A;
        Key keyRight = Key.D;
#else
        KeyCode keyJump = KeyCode.Space;
        KeyCode keyLeft = KeyCode.A;
        KeyCode keyRight = KeyCode.D;
#endif


        private void Awake()
        {
            m_Character = GetComponent<Perspective2D_PlatformerCharacter>();
        }


        private void Update()
        {
            //Get Jump from keyboard
            if (!m_Jump)
            {
                m_Jump = ExampleInput.GetKeyDown(keyJump);
            }

            //Get Jump from touch-screen
            if (uiButtonJump)
            {
                uiButtonJump = false;
                m_Jump = true;
            }
        }


        private void FixedUpdate()
        {
            // Read the inputs.
            float h = 0;

            if (ExampleInput.GetKey(keyLeft))
                h = -1;
            else if (ExampleInput.GetKey(keyRight))
                h = 1;

            // Pass all parameters to the character control script.
            m_Character.Move(h, false, m_Jump);
            m_Jump = false;
        }

        public void UIJumpButtonOn()
        {
            uiButtonJump = true;
        }
    }
}
