using UnityEngine;


namespace AmazingAssets.CurvedWorld.Example
{
    public class AngleHeightBlend : MonoBehaviour
    {
        public CurvedWorldController curvedWorldController;
        float angle1 = 0;   
        float angle2 = 0;

        public Transform pivotPoint1;
        float initialHeight1;

        public Transform pivotPoint2;
        float initialHeight2;



        private void Start()
        {
            angle1 = 900;
            angle2 = 900;

            initialHeight1 = pivotPoint1.position.y;
            initialHeight2 = pivotPoint2.position.y;
        }

        void Update()
        {
            Vector3 position = pivotPoint1.position;
            position.y = Mathf.Lerp(0, initialHeight1, Mathf.InverseLerp(0, 900, angle1));
            pivotPoint1.position = position;

            position = pivotPoint2.position;
            position.y = Mathf.Lerp(0, initialHeight2, Mathf.InverseLerp(0, 900, angle2));
            pivotPoint2.position = position;




            curvedWorldController.SetBendAngle(angle1);
            curvedWorldController.SetBendAngle2(angle2);
        }


        public void SetAngle1(float value)
        {
            angle1 = value;
        }
        public void SetAngle2(float value)
        {
            angle2 = value;
        }

    }
}
