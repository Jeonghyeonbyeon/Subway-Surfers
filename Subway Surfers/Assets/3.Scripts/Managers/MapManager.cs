using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MapManager : MonoBehaviour
{
    [SerializeField] private GameObject[] background;
    [SerializeField] private GameObject[] ground;
    [SerializeField] private float speed;

    void Start()
    {
        GameObject.Find("container").GetComponent<MeshRenderer>();
    }

    void Update()
    {
        BackgroundMovement();

        ObstacleSpawn();
    }

    void BackgroundMovement()
    {
        for (int i = 0; i < background.Length; i++)
        {
            background[i].transform.Translate(0f, 0f, -speed * Time.deltaTime);
            ground[i].transform.Translate(0f, 0f, -speed * Time.deltaTime);

            if (background[i].transform.position.z < -290f)
            {
                background[i].transform.position = new Vector3(8.15f, 3f, 250f);
            }

            if (ground[i].transform.position.z < -180)
            {
                ground[i].transform.position = new Vector3(0f, 0f, 200f);
            }
        }
    }

    void ObstacleSpawn()
    {
        //int randomObstacle = Random.Range(0, );

        //GameObject obstacleObject = Instantiate()

        //int randomSpawn = Random.Range(0, obstacleSpawnPoint.Length);
    }
}
