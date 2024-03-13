using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MapManager : MonoBehaviour
{
    [SerializeField] private GameObject[] background;
    [SerializeField] private GameObject[] ground;
    [SerializeField] private Transform[] obstacleSpawnPos;
    [SerializeField] private Material[] materials;
    private float speed = 30f;
    private bool isObstacleSpawn = true;
    private bool isGoldSpawn = true;

    void Update()
    {
        BackgroundMovement();

        if (isObstacleSpawn)
        {
            isObstacleSpawn = false;

            StartCoroutine(ObstacleSpawn());
        }

        if (isGoldSpawn)
        {
            isGoldSpawn = false;

            StartCoroutine(GoldSpawn());
        }
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

    IEnumerator ObstacleSpawn()
    {
        int randomObstacle = Random.Range(0, 6);
        int randomObstacleSpawnPos = Random.Range(0, obstacleSpawnPos.Length);
        float randomSpawnTime = Random.Range(0.5f, 1.5f);

        GameObject obstacleObject = (GameObject)Instantiate(Resources.Load($"Prefabs/Obstacle {(randomObstacle < 3 ? 0 : (randomObstacle < 4 ? 1 : (randomObstacle < 5 ? 2 : 3)))}"), obstacleSpawnPos[randomObstacleSpawnPos].transform.position, Quaternion.identity);

        if (randomObstacle < 4)
        {
            int randomObstacleObjectColor = Random.Range(0, materials.Length);

            obstacleObject.GetComponent<MeshRenderer>().sharedMaterial = materials[randomObstacleObjectColor];
        }

        yield return new WaitForSeconds(randomSpawnTime);

        isObstacleSpawn = true;
    }

    IEnumerator GoldSpawn()
    {
        int randomGoldSpawnPos = Random.Range(0, obstacleSpawnPos.Length);

        Instantiate(Resources.Load("Prefabs/Gold"), obstacleSpawnPos[randomGoldSpawnPos].transform.position, Quaternion.Euler(90f, 180f, 0f));

        yield return new WaitForSeconds(0.5f);

        isGoldSpawn = true;
    }
}
