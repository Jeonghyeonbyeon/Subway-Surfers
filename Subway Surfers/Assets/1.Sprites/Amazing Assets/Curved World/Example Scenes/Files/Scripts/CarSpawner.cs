using UnityEngine;


namespace AmazingAssets.CurvedWorld.Example
{
    public class CarSpawner : MonoBehaviour
    {
        public GameObject[] cars;
        public float spawnRate = 1;

        [Range(0f, 1f)]
        public float spawnRandomizer = 0.5f;

        [Space(10)]
        public Vector3 positionRandomizer = new Vector3(0, 0, 0);
        public Vector3 rotation = new Vector3(0, 90, 0);


        [Space(10)]
        public Vector3 moveDirection = new Vector3(1, 0, 0);
        public Vector2 movingSpeed = new Vector2(3, 5);
        
        

        float deltaTime;

        // Start is called before the first frame update
        void Start()
        {

        }

        // Update is called once per frame
        void Update()
        {
            deltaTime += Time.deltaTime;

            if(deltaTime > spawnRate)
            {
                deltaTime = 0;

                if(Random.value > spawnRandomizer)
                {
                    int index = Random.Range(0, cars.Length);

                    GameObject carObject = Instantiate(cars[index]);
                    carObject.SetActive(true);

                    carObject.transform.position = transform.position + Vector3.Scale(Random.insideUnitSphere, positionRandomizer);
                    carObject.transform.rotation = Quaternion.Euler(rotation);

                    RunnerCar carScipt = carObject.GetComponent<RunnerCar>();
                    carScipt.moveDirection = moveDirection;
                    carScipt.movingSpeed = Random.Range(movingSpeed.x, movingSpeed.y);

                   
                }
            }
        }
    }
}