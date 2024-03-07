using UnityEngine;

#if ENABLE_INPUT_SYSTEM
using UnityEngine.InputSystem;
#endif


namespace AmazingAssets.CurvedWorld.Example
{
    static public class ExampleInput
    {
#if ENABLE_INPUT_SYSTEM
        static public bool GetKeyDown(Key key)
        {
            return Keyboard.current[key].wasPressedThisFrame;
        }

        static public bool GetKey(Key key)
        {
            return Keyboard.current[key].isPressed;
        }

        static public bool GetKeyUp(Key key)
        {
            return Keyboard.current[key].wasReleasedThisFrame;
        }
#else
        static public bool GetKeyDown(KeyCode key)
        {
            return Input.GetKeyDown(key);
        }

        static public bool GetKey(KeyCode key)
        {
            return Input.GetKey(key);
        }

        static public bool GetKeyUp(KeyCode key)
        {
            return Input.GetKeyUp(key);
        }
#endif
    }
}