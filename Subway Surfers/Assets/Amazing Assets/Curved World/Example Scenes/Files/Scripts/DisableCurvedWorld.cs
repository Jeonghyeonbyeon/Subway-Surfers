using UnityEngine;


//This script is designed specially for "car racing" example scenes, to exclude object from Curved World space and paste it in the same position, but now in the World space
//
//Car wiil be excluded from Curved World space if it goes out of the road


namespace AmazingAssets.CurvedWorld.Example
{
    public class DisableCurvedWorld : MonoBehaviour
    {
        public CurvedWorld.CurvedWorldController curvedWorldController;

        [Space(10)]
        public float xMin = 0;
        public float xMax = 0;

        [Space(10)]
        public float yMin = 0;
        public float yMax = 0;

        [Space(10)]
        public float zMin = 0;
        public float zMax = 0;
        

        private void FixedUpdate()
        {
            if (xMin != xMax)
            {
                if (transform.position.x < xMin || transform.position.x > xMax)
                    ToWorldSpace();
            }
            else if (yMin != yMax)
            {
                if (transform.position.y < yMin || transform.position.y > yMax)
                    ToWorldSpace();
            }
            else if (zMin != zMax)
            {
                if (transform.position.z < zMin || transform.position.z > zMax)
                    ToWorldSpace();
            }
        }

        void ToWorldSpace()
        {
            //Disable Curved World vertex transformation by enabling "CURVEDWORLD_DISABLED_ON" keyword.
            //Note, if shader is constructed using shader graph tools, "CURVEDWORLD_DISABLED_ON" keyword has to be implemented there manually, or material shader can be replaced with 'non Curved World' shader.

            Renderer[] renderers = GetComponentsInChildren<Renderer>();
            for (int r = 0; r < renderers.Length; r++)
            {
                if (renderers[r] == null || renderers[r].sharedMaterials == null)
                    continue;

                for (int m = 0; m < renderers[r].sharedMaterials.Length; m++)
                {
                    if (renderers[r].materials[m] != null)
                        renderers[r].materials[m].EnableKeyword("CURVEDWORLD_DISABLED_ON");
                }
            }


            //Get Curved World equivalent position, but in World Space
            Vector3 realPosition = curvedWorldController.TransformPosition(transform.position);

            //And rotation too.
            Quaternion realRotation = curvedWorldController.TransformRotation(transform.position, transform.forward, transform.right);


            //Update object transformation
            transform.position = realPosition;
            transform.rotation = realRotation;


            //Dissable collider to avoid confusion with 'Curved World' physics
            Collider collider = GetComponent<Collider>();
            if (collider != null)
                collider.enabled = false;


            //This script can be disabled
            this.enabled = false;
        }
    }
}