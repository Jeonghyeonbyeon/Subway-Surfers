using UnityEngine;


namespace AmazingAssets.CurvedWorld.Example
{
    public class TeamCollision : MonoBehaviour
    {
        public int teamID = 0;

        void OnCollisionEnter(Collision collision)
        {
            if (collision.gameObject.tag == "Player")
            {

                if (collision.gameObject.GetComponent<TeamCollision>().teamID != teamID)
                {
                    collision.gameObject.GetComponent<RunnerCar>().movingSpeed = 0;

                    Vector3 f1 = new Vector3(Random.Range(-2f, -1f), Random.Range(0.1f, 0.5f), 0).normalized * 200;
                    Vector3 f2 = new Vector3(Random.Range(1f, 2f), Random.Range(0.1f, 0.5f), 0).normalized * 200;

                    collision.gameObject.GetComponent<Rigidbody>().AddForce(Random.value > 0.5f ? f1 : f2, ForceMode.Impulse);
                }
            }
        }
    }
}