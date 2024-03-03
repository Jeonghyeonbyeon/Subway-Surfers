using UnityEngine;

#if ENABLE_INPUT_SYSTEM
    using UnityEngine.InputSystem;
#endif


namespace AmazingAssets.CurvedWorld.Example
{
    public class SwitchInput : MonoBehaviour
    {
        public GameObject InputStandard;
        public GameObject InputNew;

        private void Awake()
        {
#if ENABLE_INPUT_SYSTEM
            Instantiate(InputNew);
#else
            Instantiate(InputStandard);
#endif
        }
    }
}