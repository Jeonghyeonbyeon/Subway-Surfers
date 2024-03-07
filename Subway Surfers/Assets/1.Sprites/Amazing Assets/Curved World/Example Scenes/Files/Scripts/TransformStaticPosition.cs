using UnityEngine;


namespace AmazingAssets.CurvedWorld.Example
{
    public class TransformStaticPosition : MonoBehaviour
    {
        public CurvedWorld.CurvedWorldController curvedWorldController;

        Vector3 originalPosition;
        Quaternion originalRotation;

        Vector3 forward;
        Vector3 right;

        private void Start()
        {
            originalPosition = transform.position;
            originalRotation = transform.rotation;

            forward = transform.forward;
            right = transform.right;
        }

        void Update()
        {
            if (curvedWorldController != null)
            {
                //Transform position
                transform.position = curvedWorldController.TransformPosition(originalPosition);

                //Transform normal (calcualte rotation)
                transform.rotation = curvedWorldController.TransformRotation(originalPosition, forward, right);
            }
        }
    }
}