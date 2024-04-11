using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RandomBox : MonoBehaviour
{
    private float rotateSpeed = 0.25f;

    void Update()
    {
        transform.Rotate(0f, 0f, -rotateSpeed * Time.deltaTime);
    }

    private void OnCollisionEnter(Collision other)
    {
        if (other.gameObject.CompareTag("Player"))
        {
            GameManager.instance.square += 1;
            SoundManager.instance.PlaySFX(SoundManager.instance.itemBox);

            Destroy(gameObject);
        }
    }
}
