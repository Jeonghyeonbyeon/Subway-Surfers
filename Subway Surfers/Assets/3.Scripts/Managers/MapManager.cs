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
    private bool isRandomBoxSpawn = true;

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

            StartCoroutine(UtilsSpawn());
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

        GameObject obstacleObject = (GameObject)Instantiate(Resources.Load($"Prefabs/Obstacle {(randomObstacle < 3 ? 0 : (randomObstacle < 4 ? 1 : (randomObstacle < 5 ? 2 : Random.Range(3, 6))))}"), obstacleSpawnPos[randomObstacleSpawnPos].transform.position, Quaternion.identity);

        if (randomObstacle < 4)
        {
            int randomObstacleObjectColor = Random.Range(0, materials.Length);

            obstacleObject.GetComponent<MeshRenderer>().sharedMaterial = materials[randomObstacleObjectColor];
        }

        yield return new WaitForSeconds(randomSpawnTime);

        isObstacleSpawn = true;
    }

    IEnumerator UtilsSpawn()
    {
        int randomGoldSpawnPos = Random.Range(0, obstacleSpawnPos.Length);

        Instantiate(Resources.Load("Prefabs/Gold"), obstacleSpawnPos[randomGoldSpawnPos].transform.position, Quaternion.Euler(90f, 180f, 0f));

        if (isRandomBoxSpawn)
        {
            isRandomBoxSpawn = false;

            StartCoroutine(RandomBoxSpawn());
        }

        yield return new WaitForSeconds(0.25f);

        isGoldSpawn = true;
    }

    IEnumerator RandomBoxSpawn()
    {
        int randomBoxPercentage = Random.Range(0, 10);

        if (randomBoxPercentage >= 9)
        {
            Debug.Log("RandomBox");

            int randomBoxSpawnPos = Random.Range(0, obstacleSpawnPos.Length);

            Instantiate(Resources.Load("Prefabs/Random Box"), obstacleSpawnPos[randomBoxSpawnPos].transform.position, Quaternion.identity);
        }
        yield return new WaitForSeconds(3f);

        isRandomBoxSpawn = true;
    }
}
