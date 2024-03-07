using UnityEngine;
using UnityEngine.AI;


namespace AmazingAssets.CurvedWorld.Example
{
    public class WalkingAround : MonoBehaviour
    {
        public Vector2 xMinMaxRange;
        public Vector2 zMinMaxRange;

        NavMeshAgent agent;

        // Use this for initialization
        void Start()
        {
            agent = GetComponent<NavMeshAgent>();
        }

        // Update is called once per frame
        void FixedUpdate()
        {
            if (agent.velocity.magnitude < 0.5f)
                agent.SetDestination(new Vector3(Random.Range(xMinMaxRange.x, xMinMaxRange.y), 0, Random.Range(zMinMaxRange.x, zMinMaxRange.y)));
        }
    }
}