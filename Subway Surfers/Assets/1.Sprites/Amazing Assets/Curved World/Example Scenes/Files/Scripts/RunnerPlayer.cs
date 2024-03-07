using UnityEngine;

#if ENABLE_INPUT_SYSTEM
using UnityEngine.InputSystem;
#endif


namespace AmazingAssets.CurvedWorld.Example
{
    public class RunnerPlayer : MonoBehaviour
    {
        public enum SIDE { Left, Right }


        Vector3 initialPosition;
        Vector3 newPos;
        SIDE side;


#if ENABLE_INPUT_SYSTEM
        Key moveLeftKey = Key.A;
        Key moveRightKey = Key.D;
#else
        KeyCode moveLeftKey = KeyCode.A;
        KeyCode moveRightKey = KeyCode.D;
#endif

        Animation animationComp;
        public AnimationClip moveLeftAnimation;
        public AnimationClip moveRightAnimation;

        float translateOffset = 3.5f;


        void Start()
        {
            initialPosition = transform.position;

            side = SIDE.Left;
            newPos = transform.localPosition + new Vector3(0, 0, translateOffset);

            animationComp = GetComponent<Animation>();
        }
        
        void Update()
        {
            if (ExampleInput.GetKeyDown(moveLeftKey))
            {
                if (side == SIDE.Right)
                {
                    newPos = initialPosition + new Vector3(0, 0, translateOffset);
                    side = SIDE.Left;

                    animationComp.Play(moveLeftAnimation.name);
                }
            }
            else if (ExampleInput.GetKeyDown(moveRightKey))
            {
                if (side == SIDE.Left)
                {
                    newPos = initialPosition + new Vector3(0, 0, -translateOffset);
                    side = SIDE.Right;

                    animationComp.Play(moveRightAnimation.name);
                }
            }

            transform.localPosition = Vector3.Lerp(transform.localPosition, newPos, Time.deltaTime * 10);
        }
    }
}