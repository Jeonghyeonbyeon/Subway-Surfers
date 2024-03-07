using UnityEngine;

#if ENABLE_INPUT_SYSTEM
using UnityEngine.InputSystem;
#endif


namespace AmazingAssets.CurvedWorld.Example
{
    public class CameraPan : MonoBehaviour
    {
        public float moveSpeed = 1;

#if ENABLE_INPUT_SYSTEM
        Key moveLeft = Key.A;
        Key moveRight = Key.D;
        Key moveUp = Key.W;
        Key moveDown = Key.S;
#else
        KeyCode moveLeft = KeyCode.A;
        KeyCode moveRight = KeyCode.D;
        KeyCode moveUp = KeyCode.W;
        KeyCode moveDown = KeyCode.S;
#endif

        void Update()
        {
            bool mLeft = ExampleInput.GetKey(moveLeft);
            bool mRight = ExampleInput.GetKey(moveRight);
            bool mUp = ExampleInput.GetKey(moveUp);
            bool mDown = ExampleInput.GetKey(moveDown);

            float h = 0;
            if ((mLeft && mRight) || (!mLeft && !mRight))
                h = 0;
            else if (mLeft)
                h = -1;
            else if (mRight)
                h = 1;

            float v = 0;
            if ((mUp && mDown) || (!mUp && !mDown))
                v = 0;
            else if (mUp)
                v = 1;
            else if (mDown)
                v = -1;



            Vector3 newPos = transform.position + new Vector3(h, 0, v) * moveSpeed * Time.deltaTime;

            newPos.x = Mathf.Clamp(newPos.x, -35, 35f);
            newPos.z = Mathf.Clamp(newPos.z, -35, 35f);


            transform.position = newPos;
        }
    }
}