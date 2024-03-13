using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Gold : MonoBehaviour
{
    [SerializeField] private float rotateSpeed;
    [SerializeField] private float speed;
    [SerializeField] private float maxHeight;
    private float startY;
    private bool goingUp = true;

    void Start() => startY = transform.position.y;

    void Update()
    {
        CoinEffect();

        transform.Rotate(0f, 0f, -rotateSpeed * Time.deltaTime);
    }

    void CoinEffect()
    {
        float step = speed * Time.deltaTime;
        float newY;

        if (goingUp)
        {
            newY = Mathf.MoveTowards(transform.position.y, startY + maxHeight, step);

            if (newY >= startY + maxHeight) goingUp = false;
        }
        else
        {
            newY = Mathf.MoveTowards(transform.position.y, startY, step);

            if (newY <= startY) goingUp = true;
        }
        transform.position = new Vector3(transform.position.x, newY, transform.position.z);
    }

    private void OnCollisionEnter(Collision other)
    {
        if (other.gameObject.CompareTag("Player"))
        {
            GameManager.Instance.gold += 1;

            Destroy(gameObject);
        }
    }
}
